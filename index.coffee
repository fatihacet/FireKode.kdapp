KD.enableLogs()

container = new KDView
  domId : "firepad-container"


container.on "viewAppended", ->
  firepadRef = new Firebase("https://firemirror.firebaseIO.com/").child("12345")

  codeMirror = CodeMirror container.$()[0], 
    lineNumbers: true,
    mode: 'javascript'

  firepad = Firepad.fromCodeMirror firepadRef, codeMirror
  
  firepad.on "ready", ->
    if firepad.isHistoryEmpty()
      firepad.setText '// JavaScript Editing with Firepad!\nfunction go() {\n  var message = "Hello, world.";\n  console.log(message);\n}'
  
  
appView.addSubView container