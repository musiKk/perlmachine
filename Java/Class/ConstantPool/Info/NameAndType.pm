package Java::Class::ConstantPool::Info::NameAndType;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'name_index' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_name_index'
);

has 'descriptor_index' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_descriptor_index'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_name_index( $reader->read_u2 );
	$self->_descriptor_index( $reader->read_u2 );
}

1;
