package Java::Class::Attributes::Attribute::SourceFile;

use Moose;

extends 'Java::Class::Attributes::Attribute';

has sourcefile_index => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_sourcefile_index'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_sourcefile_index( $reader->read_u2 );
}

no Moose;

__PACKAGE__->meta->make_immutable;
