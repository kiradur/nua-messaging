module UserHelpers
  def create_users
    @patient = User.create(is_patient: true, is_doctor: false, is_admin: false, first_name: "Luke", last_name: "Skywalker",inbox: Inbox.new, outbox: Outbox.new)
    @doctor = User.create(is_patient: false, is_doctor: true, is_admin: false, first_name: "Leia", last_name: "Organa",inbox: Inbox.new, outbox: Outbox.new)
    @admin = User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new)
  end
end
