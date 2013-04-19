class FireKodeUser extends JView

  constructor: (options = {}, data) ->
    
    options.cssClass = "firekode-user"
    
    super options, data
    
    @avatarView = new AvatarView
      size     : 
        width  : 36
        height : 36
    , @getData()
    
    @statusClass = @getOptions().status.toLowerCase()
    
    @userStatus = new KDView
      partial  : ""
      cssClass : @statusClass
      tooltip  :
        title  : @getOptions().status
    
  updateStatus: (newStatusText) ->
    newStatusClass = newStatusText.toLowerCase()
    @userStatus.unsetClass @statusClass
    @userStatus.setClass newStatusClass
    @userStatus?.updateTooltip title: newStatusText
    @statusClass = newStatusClass
  
  pistachio: ->
    {profile} = @getData()
    """
      {{> @avatarView}}
      <div class="firekode-user-details">
        <div class="row">#{profile.firstName} #{profile.lastName}</div>
        <div class="row">#{profile.nickname}</div>
      </div>
      {{> @userStatus}}
    """