package Java::Class::ConstantPool::Info::AbstractRef;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'class_index' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_class_index'
);

has 'name_and_type_index' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_name_and_type_index'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_class_index( $reader->read_u2 );
	$self->_name_and_type_index( $reader->read_u2 );
}

no Moose;

__PACKAGE__->meta->make_immutable;
