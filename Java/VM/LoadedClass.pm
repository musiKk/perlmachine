package Java::VM::LoadedClass;

use Moose;

use Java::Class;
use Java::Class::Fields;
use Java::VM::ClassVariable;

has class => (
	is			=> 'rw',
	isa			=> 'Java::Class',
	required	=> 1
);

# these are the static variables
# variable name => variable
has variables => (
	is			=> 'ro',
	isa			=> 'HashRef[Java::VM::ClassVariable]',
	required	=> 1,
	default		=> sub { {} }
);

# the classloader that loaded the current class
has classloader => (
	is			=> 'ro',
	isa			=> 'Java::VM::Classloader',
	required	=> 1
);

# if this is true, the static initializers of the class has yet to be executed
has requires_initialization => (
	is			=> 'rw',
	isa			=> 'Bool',
	default		=> 1
);

sub BUILD {
	my $self = shift;
	$self->_initialize_fields;
}

sub _initialize_fields {
	my $self = shift;
	
	my @fields = @{$self->class->fields->fields};
	for my $field (@fields) {
		next unless $field->is_static;
		
		my $field_name = $field->name;
		
		my $variable = Java::VM::ClassVariable->new( field => $field );
		$variable->set_default;
		$self->variables->{$field_name} = $variable;
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
