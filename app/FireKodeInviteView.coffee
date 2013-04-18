{nickname} = KD.whoami().profile

class FireKodeInviteView extends JView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
    @connectedUsers = {}
    @userViews      = {}
    
    @label   = new KDView
      cssClass : "firekode-invite-view"
      partial  : "You can invite your friends to this session."
      
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
      title    : "Invite"
      callback : =>
        accounts  = @userController.getSelectedItemData()
        @sendRequest account for account in accounts when account
    
    @inviteButton.disable()
    
    @doneButton = new KDButtonView
      title    : "Done"
      callback : =>
        @getDelegate().splitView.resizePanel 0, 1
        
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
    subject    = "FireKode Session Request from #{nickname}"
    body       = """
      Hi #{to}!
      
      #{userName} wants to start a FireKode session with you.
      
      To join this session, open FireKode app and click "Join" button and paste your session key to session key field.
      
      Your session key is: #{@getDelegate().sessionKey}
      
      If you don't have FireKode, you can install FireKode app from Koding App catalog.
      
      Enjoy!
    """
    
    return if to is nickname
    
    KD.remote.api.JPrivateMessage.create {
      to
      subject
      body
    }
    
    @showUserInList userAccount
    @getDelegate().showNotification "Invitation sent to #{to}"
  
  showUserInList: (userAccount, status = "Invited") ->
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
        
  pistachio: ->
    """
      {{> @label}}
      {{> @wrapper}}
      {{> @userController.getView()}}
      {{> @inviteButton}}
      {{> @doneButton}}
      {{> @userList}}
    """