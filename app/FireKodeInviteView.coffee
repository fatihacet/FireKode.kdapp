{nickname} = KD.whoami().profile

class FireKodeInviteView extends JView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    @connectedUsers = {}
    @userViews      = {}
    
    @label   = new KDView
      cssClass : "firekode-invite-text"
      partial  : "Type a name to start collabrate together!"
      
    @wrapper = new KDView
      cssClass : "completed-items"
      
    @userController = new KDAutoCompleteController
      form                : new KDFormView
      name                : "userController"
      itemClass           : MemberAutoCompleteItemView
      itemDataPath        : "profile.nickname"
      outputWrapper       : @wrapper
      selectedItemClass   : MemberAutoCompletedItemView
      listWrapperCssClass : "users"
      submitValuesAsText  : yes
      dataSource          : (args, callback) =>
        {inputValue} = args
        blacklist = (data.getId() for data in @userController.getSelectedItemData())
        KD.remote.api.JAccount.byRelevance inputValue, {blacklist}, (err, accounts) =>
          callback accounts

    @userController.on "ItemListChanged", =>
      accounts = @userController.getSelectedItemData()
      if accounts.length > 0 then @inviteButton.enable() else @inviteButton.disable()
        
    @inviteButton = new KDButtonView
      cssClass : "firekode-invite-button clean-gray"
      title    : "Invite"
      callback : =>
        accounts  = @userController.getSelectedItemData()
        for account in accounts
          return if not account or @userViews[account.profile.nickname]
          @sendRequest account
    
    @inviteButton.disable()
    
    @userList = new KDView 
      cssClass : "firekode-user-list"
      
    @on "FireKodeUserListChanged", (clients) =>
      @updateUserList clients
      
    @on "FireKodeCreateUserList", (clients) =>
      delete clients[nickname] # remove current user
      
      for clientName of clients
        KD.remote.api.JAccount.one "profile.nickname": clientName, {}, (err, jAccount) =>
          @showUserInList jAccount, "Connected"
    
  sendRequest: (userAccount) ->
    to         = userAccount.profile.nickname
    {profile}  = KD.whoami()
    userName   = "#{profile.firstName} #{profile.lastName} (@#{nickname})"
    subject    = "FireKode Session Request"
    body       = """
      Hey!
      
      I want to share my code with you. Come on let's collabrate together.
      
      To join my session, open FireKode app and click "Join" button then paste the session key and hit enter.
      
      My session key is: #{@getDelegate().sessionKey}
      
      If you don't have FireKode, you can install FireKode app from Koding App catalog.
    """
    
    return if to is nickname
    
    KD.remote.api.JPrivateMessage.create {
      to
      subject
      body
    }
    
    @showUserInList userAccount
    @getDelegate().showNotification "Invitation sent to #{to}", 4000
    
  showUserInList: (userAccount, status = "Invited") ->
    return if @userViews[userAccount.profile.nickname]
    fireKodeUserView = new FireKodeUser { status }, userAccount
    @userList.addSubView fireKodeUserView
    @userViews[userAccount.profile.nickname] = fireKodeUserView
    
  updateUserList: (clients) ->
    for username of @userViews
      userView = @userViews[username]
      if clients[username]
        userView.updateStatus "Connected"
        @connectedUsers[username] = username
      else if clients[username] is undefined and @connectedUsers[username]
        userView.updateStatus "Disconnected"
        delete @connectedUsers[username]
      
      delete clients[username]
    
    @emit "FireKodeCreateUserList", clients
        
  pistachio: ->
    """
      {{> @label}}
      {{> @userController.getView()}}
      {{> @inviteButton}}
      {{> @wrapper}}
      {{> @userList}}
    """