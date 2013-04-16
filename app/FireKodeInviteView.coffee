class FireKodeInviteView extends JView
  
  constructor: (options = {}, data) ->
    
    super options, data
    
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
        @sendRequest account.profile.nickname for account in accounts when account
        
    
    @inviteButton.disable()
    
  sendRequest: (to) ->
    {profile}  = KD.whoami()
    {nickname} = profile
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
    
    KD.remote.api.JPrivateMessage.create {
      to
      subject
      body
    } 
  
  pistachio: ->
    """
      {{> @label}}
      {{> @wrapper}}
      {{> @userController.getView()}}
      {{> @inviteButton}}
    """