class FireKodeUser extends JView

  constructor: (options = {}, data) ->
    
    options.cssClass = "firekode-user"
    
    super options, data
    
    @avatarView = new AvatarView
      size     : 
        width  : 36
        height : 36
    , @getData()
    
    @userStatus = new KDView
      partial  : @getOptions().status
    
  updateStatus: (newStatusText) ->
    @userStatus.updatePartial newStatusText
  
  pistachio: ->
    {profile} = @getData()
    """
      {{> @avatarView}}
      <div class="firekode-user-details">
        #{profile.firstName} #{profile.lastName} 
        {{> @userStatus}}
      </div>
    """