KD.enableLogs()

class FireKode extends JView
  
  constructor: (options, data) ->
    
    super options, data
    
    @sessionKey = @getOptions().sessionKey or "#{KD.utils.generatePassword 18, no}#{KD.utils.getRandomNumber 9999}#{KD.utils.generatePassword 18, no}"
    
    @header = new FireKodeHeader
      delegate: @
    
    @container = new KDView
      domId : "firekode-container#{KD.utils.getRandomNumber()}"
    
    @container.on "viewAppended", =>
      @firepadRef = new Firebase("https://firemirror.firebaseIO.com/").child @sessionKey
    
      @codeMirrorEditor = CodeMirror @container.$()[0],
        lineNumbers : true
        mode        : "javascript"
    
      KD.utils.wait 300, =>
        @firepad = Firepad.fromCodeMirror @firepadRef, @codeMirrorEditor, userId: KD.whoami().profile.nickname
        
        @firepad.on "ready", =>
          appView.getSubViews()[0].destroy() if @getOptions().sharedSession
          
          if @firepad.isHistoryEmpty()
            @firepad.setText """
              // JavaScript Editing with Firepad!
              function go() {
                var message = "Hello, world.";
                console.log(message);
              }
            """
            
        @firepadRef.on "child_changed", (snapshot) =>
          return unless snapshot.name() is "users"
          @inviteView.emit "FireKodeUserListChanged", snapshot.val()
          
        @firepadRef.on "child_added", (snapshot) =>
          return unless snapshot.name() is "users"
          @inviteView.emit "FireKodeCreateUserList", snapshot.val()
    
    @inviteView = new FireKodeInviteView
      delegate    : @
          
    @splitView = new KDSplitView
      cssClass    : "firekode-split-view"
      type        : "vertical"
      resizable   : yes
      animated    : yes
      sizes       : [ "100%", null ]
      views       : [ @container, @inviteView ]
      
    @on "KDObjectWillBeDestroyed", =>
      @utils.killRepeat @userListCheckInterval
      @firepad.dispose()
      
    # TODO: Remove export
    window.fk = @
      
  joinSession: (key) ->
    appView.destroySubViews()
    appView.addSubView @sessionLoading = new KDLoaderView
      title   : "Loading your session"
      size    :
        width : 48
    
    @sessionLoading.show()
    
    appView.addSubView new FireKode
      sessionKey    : key
      sharedSession : yes
      
  showNotification: (content) ->
    return unless content
    new KDNotificationView {
      type : "tray"
      content
    }
      
  pistachio: ->
    """
      {{> @header}}
      {{> @splitView}}
    """