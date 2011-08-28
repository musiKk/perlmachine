package Java::VM::WithFields;
#TODO find a better name for a 'field having entity'

use Moose;

use Java::VM::Field;

# maps "class-name" . "field-name" . "field-descriptor" => field
# the class-name is needed for field hiding in sub classes and the descriptor
# is bonus (it provides however type checking for free)
has fields => (
	is		=> 'ro',
	isa		=> 'HashRef[Java::VM::Field]',
	default	=> sub { {} }
);

sub get_field {
	my $self = shift;
	my $fieldref = shift;
	
	my $key = $self->_make_key( $fieldref );
	return $self->fields->{$key} if( exists $self->fields->{$key} );
	
	undef;
}

sub create_field {
	my $self = shift;
	my $field = shift;
	my $fieldref = shift;
	
	my $key = $self->_make_key( $fieldref );
	my $new_field = Java::VM::Field->new( field	=> $field );
	$self->fields->{$key} = $new_field;
	
	$new_field;
}

# creates a unique key from a fieldref
sub _make_key {
	my $self = shift;
	my $fieldref = shift;
	$fieldref->[0] . $fieldref->[1]->[0] . $fieldref->[1]->[1];
}

# takes [ [ $loadedclass, $field ], ... ], creates appropriate fields and
# initializes them to their default value
sub create_fields {
	my $self = shift;
	my $fields = shift;
	
	for my $class_and_field ( @$fields ) {
		my $class = $class_and_field->[0];
		my $field = $class_and_field->[1];
		
		my $new_field = $self->create_field(
			$field,
			[ $class->class->get_name,
				[ $field->name, $field->descriptor ] ] );
		my $variable = Java::VM::Variable->new ( descriptor => $field->descriptor );
		$variable->set_default;
		$new_field->value( $variable );
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
