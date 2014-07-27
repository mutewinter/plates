{ hasOne } = FP

module.exports = App.PlateInvite = App.Model.extend
  toUser: hasOne('user', embedded: false)
  fromUser: hasOne('user', embedded: false)
  plate: hasOne('plate', embedded: false)

App.PlateInvite.reopenClass
  firebasePath: 'plate_invites/{{toUser.id}}'
