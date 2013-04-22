class FireKodeSaveModal extends KDObject
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    modal = new KDModalView
      title    : "Save your file"
    
    input = new KDHitEnterInputView
      type     : "text"
      callback : (keyword) =>
        return unless keyword
        {nickname} = KD.whoami().profile
        rootPath = "/Users/#{nickname}/Documents/FireKode/"
        fullPath = "#{rootPath}/#{keyword}"
        
        KD.getSingleton("kiteController").run "mkdir -p #{rootPath}", (err, res) =>
          return if err
          file = FSHelper.createFileFromPath "#{fullPath}"
          file.save @getOptions().content or "", (err, res) =>
            return if err
            @emit "FireKodeFileSaved", fullPath, file
    
    modal.addSubView input
    
    modal.show()