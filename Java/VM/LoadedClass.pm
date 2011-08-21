package Java::VM::LoadedClass;

use Moose;

use Java::Class;
use Java::Class::Fields;
use Java::VM::WithFields;

extends 'Java::VM::WithFields';

has class => (
	is			=> 'rw',
	isa			=> 'Java::Class',
	required	=> 1
);

# the classloader that loaded the current class
has classloader => (
	is			=> 'ro',
	isa			=> 'Java::VM::Classloader',
	required	=> 1
);

# if this is true, the static initializer of the class has yet to be executed
has requires_initialization => (
	is			=> 'rw',
	isa			=> 'Bool',
	default		=> 1
);

has super_class => (
	is			=> 'rw',
	isa			=> 'Maybe[Java::VM::LoadedClass]'
);

sub BUILD {
	my $self = shift;
	
	my $static_fields = [ map { [ $self, $_ ] } $self->class->get_static_fields ];
	$self->create_fields( $static_fields );
}

# returns a list of class-field pairs for the whole class hierarchy (instance fields only)
sub _get_all_instance_fields {
	my $self = shift;
	my $fields = [];
	for my $field ( $self->class->get_instance_fields ) {
		push @$fields, [ $self, $field ];
	}
	if( $self->super_class ) {
		push @$fields, @{$self->super_class->_get_all_instance_fields};
	}
	$fields;
}

no Moose;

__PACKAGE__->meta->make_immutable;
