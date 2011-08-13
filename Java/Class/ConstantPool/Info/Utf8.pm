package Java::Class::ConstantPool::Info::Utf8;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'length' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_length'
);

has 'string' => (
	is		=> 'ro',
	isa		=> 'Str',
	writer	=> '_string'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_length( $reader->read_u2 );
	$self->_string( $reader->read_bytes( $self->length ) );
}

no Moose;

__PACKAGE__->meta->make_immutable;
