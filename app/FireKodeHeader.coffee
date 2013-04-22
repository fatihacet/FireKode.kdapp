class FireKodeHeader extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "editor-header"
    
    super options, data
    
    @kodingSessionButton = new KDCustomHTMLView
      tagName: "span"
    
    if @getDelegate().sessionKey isnt "Koding"
      @kodingSessionButton = new KDButtonView
        cssClass  : "editor-button firekode-koding-session"
        partial   : "Join Koding Session"
        callback  : =>
          @getDelegate().joinSession "Koding"
    
    @buttonsContainer = new KDView
      cssClass  : "header-buttons firekode-header-buttons"
      
    @buttonsContainer.addSubView new KDCustomHTMLView
      cssClass  : "editor-button firekode-question-mark"
      partial   : ""
      click     : =>
        new KDModalView
          overlay  : yes
          title    : "About FireKode"
          cssClass : "firekode-about-modal"
          width    : 500
          content  : """
            <p>FireKode is an real-time collaborative text editor application for Koding. It provides true collaborative editing with your friends in Koding. Share your session key to start collaborating together.</p>
            <p>And here is your session key: <strong>#{@getDelegate().sessionKey}</strong></p>
          """
      
    @buttonsContainer.addSubView new KDButtonView
      cssClass  : "editor-button"
      title     : "Join"
      callback  : => @showJoinModal()
      
    @inviteViewVisible = no
    
    @buttonsContainer.addSubView @inviteButton = new KDButtonView
      cssClass   : "editor-button firekode-friends-button clean-gray"
      title      : "Your Friends"
      callback   : =>
        width    = "350px"
        title    = "Close"
        
        if @inviteViewVisible 
          width  = "0px"
          title  = "Your Friends"
        
        @getDelegate().splitView.resizePanel width, 1
        @inviteButton.updatePartial title
        @inviteViewVisible = !@inviteViewVisible
  
  showJoinModal : ->
    modal = new KDModalView
      title     : "Join to FireKode session"
      width     : 420
    
    modal.addSubView new KDView
      cssClass  : "firekode-modal-content"
      partial   : "To join a FireKode session, just paste your session key and hit enter."
    
    modal.addSubView new KDHitEnterInputView
      type      : "text"
      cssClass  : "firekode-session-input"
      callback  : (key) =>
        @getDelegate().joinSession key
        modal.destroy()
  
  pistachio: ->
    """
      {{> @kodingSessionButton}}
      {{> @buttonsContainer}}
    """