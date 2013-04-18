class FireKodeHeader extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "editor-header"
    
    super options, data
    
    @buttonsContainer = new KDView
      cssClass  : "header-buttons firekode-header-buttons"
      
    @buttonsContainer.addSubView new KDCustomHTMLView
      cssClass  : "editor-button firekode-question-mark"
      partial   : ""
      click     : =>
        new KDModalView
          overlay  : yes
          title    : "About FireKode"
          cssClass : "firekode-modal"
          content  : """
            Your session key is: #{@getDelegate().sessionKey}
          """
      
    @buttonsContainer.addSubView new KDButtonView
      cssClass  : "editor-button"
      title     : "Join"
      callback  : => @showJoinModal()
    
    @buttonsContainer.addSubView new KDButtonView
      cssClass  : "editor-button"
      title     : "Invite Friends"
      callback  : => @getDelegate().splitView.resizePanel "350px", 1
  
  showJoinModal : ->
    modal = new KDModalView
      title     : "Join to FireKode session"
    
    modal.addSubView new KDView
      cssClass  : "firekode-modal-content"
      partial   : "Paste your session key to join a session"
    
    modal.addSubView new KDHitEnterInputView
      type      : "text"
      cssClass  : "firekode-session-input"
      callback  : (key) =>
        @getDelegate().joinSession key
        modal.destroy()
  
  pistachio: ->
    """
      {{> @buttonsContainer}}
    """