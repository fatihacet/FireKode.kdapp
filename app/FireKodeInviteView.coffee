class FireKodeInviteView extends JView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    @label = new KDView
      cssClass : "firekode-invite-view"
      partial  : "You can invite your friends to this session."
      
  pistachio: ->
    """
      {{> @label}}
    """