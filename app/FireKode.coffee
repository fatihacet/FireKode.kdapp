KD.enableLogs()

class FireKode extends JView
  
  constructor: (options, data) ->
    
    super options, data
    
    @header = new FireKodeHeader
      delegate: @
    
    @container = new KDView
      domId : "firekode-container#{KD.utils.getRandomNumber()}"
    
    @container.on "viewAppended", =>
      @firepadRef = new Firebase("https://firemirror.firebaseIO.com/").child "12345"
    
      @codeMirrorEditor = CodeMirror @container.$()[0],
        lineNumbers: true
        mode: 'javascript'
    
      @firepad = Firepad.fromCodeMirror @firepadRef, @codeMirrorEditor
      
      @firepad.on "ready", =>
        if @firepad.isHistoryEmpty()
          @firepad.setText '// JavaScript Editing with Firepad!\nfunction go() {\n  var message = "Hello, world.";\n  console.log(message);\n}'
    
    @inviteView = new FireKodeInviteView()
          
    @splitView = new KDSplitView
      cssClass    : "firekode-split-view"
      type        : "vertical"
      resizable   : yes
      animated    : yes
      sizes       : [ "100%", null ]
      views       : [ @container, @inviteView ]
          
  pistachio: ->
    """
      {{> @header}}
      {{> @splitView}}
    """