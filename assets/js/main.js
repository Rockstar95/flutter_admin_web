if(!methodChannelObject){
    var methodChannelObject = {
        hideNativeContentLoader: function () {
            window.parent.flutter_inappwebview
                .callHandler('hideNativeContentLoader');
        },
        OnLineCourseClose: function () {
            window.parent.flutter_inappwebview
                .callHandler('OnLineCourseClose');
        },
        LMSSetRandomQuestionNosWithRandomqusseq: function (value) {
            // Android: LMSSetRandomQuestionNosWithRandomqusseq
            // iOS: LMSSetRandomQuestionNos
            window.parent.flutter_inappwebview
                .callHandler('LMSSetRandomQuestionNosWithRandomqusseq', value);
        },
        AddOfflineAttachementWithQuesid: function (value) {
            // Android: AddOfflineAttachementWithQuesid
            // iOS: AddOfflineAttachement
            window.parent.flutter_inappwebview
                .callHandler('AddOfflineAttachementWithQuesid', value);
        },
        LMSGetRandomQuestionNos: function () {
            window.parent.flutter_inappwebview
                .callHandler('LMSGetRandomQuestionNos');
        },
        PlayAudioWithSrcStatus: function (src, status) {
            // Android: PlayAudioWithSrcStatus
            // iOS: PlayAudio
            window.parent.flutter_inappwebview
                .callHandler('PlayAudioWithSrcStatus', src, status);
        },
        saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType: function (contentid, usernotePageID, strsqeid, text, noteID, action) {
            // Android: saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType
            // iOS: saveUserPageNotes
            window.parent.flutter_inappwebview
                .callHandler('saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType', contentid, usernotePageID, strsqeid, text, noteID, action);
        },
        DeletePageNoteWithContentIDPageIDNoteCount: function (contentid, usernotePageID, noteID) {
            // Android: DeletePageNoteWithContentIDPageIDNoteCount
            // iOS: DeletePageNote
            window.parent.flutter_inappwebview
                .callHandler('DeletePageNoteWithContentIDPageIDNoteCount', contentid, usernotePageID, noteID);
        },
        GetUserPageNotesWithContentIDPageID: function (contentid, usernotePageID) {
            // Android: GetUserPageNotesWithContentIDPageID
            // iOS: GetUserPageNotes
            window.parent.flutter_inappwebview
                .callHandler('GetUserPageNotesWithContentIDPageID', contentid, usernotePageID);
        },
        GetUserTextResponsesWithSeqIDUserID: function (cid, uid) {
            // Android: GetUserTextResponsesWithSeqIDUserID
            // iOS: instancy.textresponses
            window.parent.flutter_inappwebview
                .callHandler('GetUserTextResponsesWithSeqIDUserID', cid, uid);
            return "";
        },
        getPercentCompleted: function (value) {
            // Android: getPercentCompleted
            // iOS: cmi.progress_measure
            window.parent.flutter_inappwebview
                .callHandler('getPercentCompleted', value);
        },
        SaveLocationWithLocation: function (value) {
            // Android: SaveLocationWithLocation
            // iOS: cmi.core.lesson_location
            window.parent.flutter_inappwebview
                .callHandler('SaveLocationWithLocation', value);
        },
        SaveQuestionDataWithQuestionData: function (value) {
            // Android: SaveQuestionDataWithQuestionData
            // iOS: cmi.interaction
            window.parent.flutter_inappwebview
                .callHandler('SaveQuestionDataWithQuestionData', value);
        },
        RetakeCourseWithIsRetake: function (value) {
            // Android: RetakeCourseWithIsRetake
            // iOS: instancy.retake
            window.parent.flutter_inappwebview
                .callHandler('RetakeCourseWithIsRetake', value);
        },
        updatePercentCompletedWithProgressValue: function (value) {
            // Android: updatePercentCompletedWithProgressValue
            // iOS: cmi.progress_measure
            window.parent.flutter_inappwebview
                .callHandler('updatePercentCompletedWithProgressValue', value);
        },
        UpdateUserTextResponsesWithSeqIDUserIDTextResponses: function (cid, uid, textResponses) {
            // Android: UpdateUserTextResponsesWithSeqIDUserIDTextResponses
            // iOS: instancy.textresponses
            window.parent.flutter_inappwebview
                .callHandler('UpdateUserTextResponsesWithSeqIDUserIDTextResponses', cid, uid, textResponses);
        },
        LMSGetPooledQuestionNos: function () {
            window.parent.flutter_inappwebview
                .callHandler('LMSGetPooledQuestionNos');
            return "";
        },
        LMSSetPooledQuestionNosWithStr: function (pooledQuestionsString) {
            window.parent.flutter_inappwebview
                .callHandler('LMSSetPooledQuestionNosWithStr', pooledQuestionsString);
        },
        XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404: function (endpoint, url, method, data, auth, callback, ignore404, extraHeaders, actor) {
            window.parent.flutter_inappwebview
                .callHandler('XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404', pooledQuestionsString, endpoint, url, method, data, auth, callback, ignore404, extraHeaders, actor);
        },
        XHR_GetStateWithStateKey: function (stateId) {
            window.parent.flutter_inappwebview
                .callHandler('XHR_GetStateWithStateKey', stateId);
        },
        widgetVideoRecordingWithFromSource: function (source) {
            window.parent.flutter_inappwebview
                .callHandler('widgetVideoRecordingWithFromSource', source);
        },
        widgetVideoRecordingFromSource: function (source) {
            window.parent.flutter_inappwebview
                .callHandler('widgetVideoRecordingFromSource', source);
        },
        SCORM_LMSInitialize: async function () {
            let result = await window.parent.flutter_inappwebview
                .callHandler('SCORM_LMSInitialize');
            return result;
        },
        SCORM_LMSGetValueWithGetValue: async function (source) {
            let result = await window.parent.flutter_inappwebview
                .callHandler('SCORM_LMSGetValueWithGetValue', source);
            return result;
        },
        SCORM_LMSSetValueWithTotalValue: async function (source) {
            let result = await window.parent.flutter_inappwebview
                .callHandler('SCORM_LMSSetValueWithTotalValue', source);
            return result;
        },
    };

    window.parent.MobileJSInterface = methodChannelObject;
    var MobileJSInterface = methodChannelObject;

    window.parent.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
        console.log('flutterInAppWebViewPlatformReady initialized');
    });
} else {
    console.log('methodChannelObject already exists');
}
