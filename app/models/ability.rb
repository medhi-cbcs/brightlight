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
    can :manage, StudentBook
    can :manage, BookLoan
    can :manage, BookFine
    can :manage, BookLabel
    can :manage, StandardBook
    can :manage, Currency
    can :manage, GradeSection
    can :manage, Template
    can :manage, BookReceipt
    can :update, Student  # for nested form in StudentBook
    can :update, Employee # for nested form in BookLoan
    can :manage, BookLoan
    can :manage, Subject
    can :manage, LoanCheck
    can :read, :all
	end

	def manager
    can :manage, CourseSection
    can :manage, GradeSection
    can :manage, StudentBook
    can :manage, StandardBook
    can [:create,:read,:update,:destroy], Carpool
    can :read, :all
	end

  # Teacher
  def teacher
    can :manage, CourseSection, instructor: @user.employee
    can :manage, GradeSection, homeroom: @user.employee
    can :manage, StudentBook #, grade_section: GradeSection.find_by_homeroom_id(@user.employee)
    can :manage, StandardBook
    can :scan, BookLoan
    can :read, BookLoan
    can [:read,:create], LoanCheck
    can [:create,:read,:update,:destroy], Carpool
    can :read, :all
  end

  def staff
    can [:create,:read,:update,:destroy], Carpool
    can :manage, Transport
    can :read, :all
  end

  def carpool
    can [:manage], Carpool
    can :read, :all
  end

  def student
    can :read, CourseSection
    can :read, GradeLevel
    can :read, GradeSection
    can :read, Course
  end

	# Guest, a non-signed in user, can only view public articles
	def guest
	end
end
