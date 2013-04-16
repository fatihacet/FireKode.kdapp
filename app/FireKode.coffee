KD.enableLogs()

class FireKode extends JView
  
  constructor: (options, data) ->
    
    super options, data
    
    @sessionKey = @getOptions().sessionKey or "#{KD.utils.generatePassword 18, no}-#{KD.utils.getRandomNumber 9999}-#{KD.utils.generatePassword 18, no}"
    
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
        @firepad = Firepad.fromCodeMirror @firepadRef, @codeMirrorEditor
        
        @firepad.on "ready", =>
          if @firepad.isHistoryEmpty()
            @firepad.setText """
              // JavaScript Editing with Firepad!
              function go() {
                var message = "Hello, world.";
                console.log(message);
              }
            """
        
        appView.getSubViews()[0].destroy() if @getOptions().restoredSession
    
    @inviteView = new FireKodeInviteView
      delegate    : @
          
    @splitView = new KDSplitView
      cssClass    : "firekode-split-view"
      type        : "vertical"
      resizable   : yes
      animated    : yes
      sizes       : [ "100%", null ]
      views       : [ @container, @inviteView ]
      
  joinSession: (key) ->
    appView.destroySubViews()
    appView.addSubView @sessionLoading = new KDLoaderView
      title   : "Loading your session"
      size    :
        width : 48
        
    @sessionLoading.show()
    
    appView.addSubView new FireKode
      sessionKey      : key
      restoredSession : yes
      
  pistachio: ->
    """
      {{> @header}}
      {{> @splitView}}
    """