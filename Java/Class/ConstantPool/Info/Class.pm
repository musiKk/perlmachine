package Java::Class::ConstantPool::Info::Class;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'name_index' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_name_index'
);

sub BUILD {
	my $self = shift;
	$self->_name_index( $self->reader->read_u2 );
}

no Moose;

__PACKAGE__->meta->make_immutable;
