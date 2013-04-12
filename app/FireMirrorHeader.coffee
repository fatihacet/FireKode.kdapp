class FireMirrorHeader extends JView
  
  constructor: (options = {}, data) ->
    
    options.cssClass = "editor-header"
    
    super options, data
    
    @inviteFriendButton = new KDButtonView
      title: "Invite Friend"
    
  pistachio: ->
    """
      {{> @inviteFriendButton}}
    """