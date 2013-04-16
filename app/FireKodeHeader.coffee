class FireKodeHeader extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "editor-header"
    
    super options, data
    
    @buttonsContainer = new KDView
      cssClass: "header-buttons"
      
    @buttonsContainer.addSubView inviteFriendButton = new KDButtonView
      cssClass : "editor-button"
      title    : "Invite Friends"
      callback : =>
        @getDelegate().splitView.resizePanel "350px", 1, => 
          log "resize done"
    
  pistachio: ->
    """
      {{> @buttonsContainer}}
    """