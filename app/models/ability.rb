class Ability
  include CanCan::Ability

  def initialize(user)

		@user = user || User.new # guest user (not logged in)

		@user.roles << 'guest' if @user.new_record?

		# This one calls each method according to the roles
		@user.roles.each { |role| send(role.downcase) }
	end

  # Admin user can do anything
	def admin
		can :manage, :all
	end

	# Inventory staff
	def inventory
		can :manage, BookTitle
		can :manage, BookEdition
		can :manage, BookCopy
    can :manage, BookCondition
    can :manage, CopyCondition
    can :read, :all
	end

  # Teacher
  def teacher
    can :manage, CourseSection, instructor: @user.person.try(teacher)
    can :manage, GradeSection, homeroom: @user.person.try(teacher)
    can :read, :all
  end

	# Guest, a non-signed in user, can only view public articles
	def guest
	end
end
