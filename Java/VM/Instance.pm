package Java::VM::Instance;

use Moose;

use Carp;
use overload '""' => \&stringify;

use Java::VM::WithFields;

extends 'Java::VM::WithFields';

has class => (
	is			=> 'ro',
	isa			=> 'Maybe[Java::VM::LoadedClass]',
	default		=> undef
);

has null => (
	is			=> 'ro',
	isa			=> 'Bool',
	default		=> 0
);

around 'get_field' => sub {
	my $orig = shift;
	my $self = shift;
	my $fieldref = shift;
	
	my $class_name = $fieldref->[0];
	my $method_name_and_type = $fieldref->[1];
	
	# first we search the class from the fieldref
	my $target_class = $self->class;
	while( $target_class->class->get_name ne $class_name ) {
		my $super_class = $target_class->super_class;
		if( $super_class ) {
			$target_class = $super_class;
		} else {
			print "NoSuchFieldError\n";
			return undef;
		}
	}
	
	# now we look for the field
	until( $target_class->class->get_field( $method_name_and_type ) ) {
		my $super_class = $target_class->super_class;
		if( $super_class ) {
			$target_class = $super_class;
		} else {
			print "NoSuchFieldError\n";
			return undef;
		}
	}
	$self->$orig( [ $target_class->class->get_name, $fieldref->[1] ] );
};

sub BUILD {
	my $self = shift;
	
	return if $self->null;
	
	$self->create_fields( $self->class->_get_all_instance_fields );
}

sub stringify {
	my $self = shift;
	
	if( ! $self->null ) {
		'instance of class ' . $self->class->class->get_name;
	} else {
		'null-instance';
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
