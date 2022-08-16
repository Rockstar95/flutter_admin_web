import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/wikiupload_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/wiki_categoryresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/wikiupload_state.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/wikiuploadrepo/wikiupload_repositry_builder.dart';

class WikiUploadBloc extends Bloc<WikiUploadEvent, WikiUploadState> {
  bool isFirstLoading = true;

  List<WikiCategoryModel> wikiCategorieslist = [];

  String fileName = '';
  List<PlatformFile> _paths = [];
  String _extension = "";
  bool _multiPick = false;
  Uint8List? fileBytes;

  WikiUploadRepository wikiUploadRepository;

  WikiUploadBloc({required this.wikiUploadRepository})
      : super(WikiUploadState.completed(null)) {
    on<PostWikiUploadEvent>(onEventHandler);
    on<OpenFileExplorerEvent>(onEventHandler);
    on<GetWikiCategoriesEvent>(onEventHandler);
  }

  FutureOr<void> onEventHandler(WikiUploadEvent event, Emitter emit) async {
    print("WikiUploadBloc onEventHandler called for ${event.runtimeType}");
    Stream<WikiUploadState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (WikiUploadState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  WikiUploadState get initialState => IntitialWikiUploadState.completed('data');

  @override
  Stream<WikiUploadState> mapEventToState(WikiUploadEvent event) async* {
    try {
      if (event is PostWikiUploadEvent) {
        yield PostWikiUploadState.loading('Please wait');
        Response? apiResponse = await wikiUploadRepository.uploadWikiFileData(
            categoryIds: event.categoryId,
            isUrl: event.isUrl,
            fileBytes: event.fileBytes,
            mediaTypeID: event.mediaTypeID,
            objectTypeID: event.objectTypeID,
            title: event.title,
            componentID: 1,
            cMSGroupId: 1,
            keywords: event.keywords,
            shortDesc: event.shortDesc,
            orgUnitID: int.parse(ApiEndpoints.siteID),
            eventCategoryID: '',
        );

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          yield PostWikiUploadState.completed();
        }
        else if (apiResponse?.statusCode == 401) {
          yield PostWikiUploadState.error('401');
        }
        else {
          yield PostWikiUploadState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }

      if (event is OpenFileExplorerEvent) {
        yield OpenFileExplorerState.loading('Please wait');
        fileName = await openFileExplorer(event.pickingType);

        yield OpenFileExplorerState.completed(fileName: fileName);

        print('file name here $fileName $fileBytes');
      }

      if (event is GetWikiCategoriesEvent) {
        yield GetWikiCategoriesState.loading('Please wait ');
        Response? apiResponse = await wikiUploadRepository.getWikiCategories(
            intComponentID: 0,
            intSiteID: int.parse(ApiEndpoints.siteID),
            intUserID: 0,
            locale: '',
            strType: 'cat');

        if (apiResponse?.statusCode == 200) {
          isFirstLoading = false;

          WikiCategoryResponse wikiCategoryResponse =
              wikiCategoryResponseFromJson(apiResponse?.body ?? "{}");
          print('wikiCategoryResponse ${wikiCategoryResponse.table.length}');
          wikiCategorieslist = wikiCategoryResponse.table;
          yield GetWikiCategoriesState.completed(
              fileName: apiResponse?.body ?? "");
        } else if (apiResponse?.statusCode == 401) {
          yield GetWikiCategoriesState.error('401');
        } else {
          yield GetWikiCategoriesState.error('Something went wrong');
        }
      }
    } catch (e, s) {
      print("Error in WikiUploadBloc mapEventToState:$e");
      print(s);
      isFirstLoading = false;
      //yield GetListState.error("Error  $e");
    }
  }

  Future<String> openFileExplorer(FileType _pickingType) async {
    if (_pickingType == FileType.custom) {
      _extension = 'xlsx,pptx,docx,txt,doc,pdf';
    }
    try {
      _paths = (await FilePicker.platform.pickFiles(
            type: _pickingType,
            allowMultiple: _multiPick,
            allowedExtensions: (_extension.isNotEmpty)
                ? _extension.replaceAll(' ', '').split(',')
                : null,
          ))
              ?.files ??
          [];
    } on PlatformException catch (e, s) {
      print("Unsupported operation" + e.toString());
      print(s);
    } catch (ex, s) {
      print(ex);
      print(s);
    }
    PlatformFile? file = _paths.isNotEmpty ? _paths.first : null;

    if(file != null) {
      fileName = file != null
          ? file.name.replaceAll('(', ' ').replaceAll(')', '')
          : '';
      fileBytes = file.bytes;

      fileName = fileName.trim();
    }
    return fileName;
  }
}
