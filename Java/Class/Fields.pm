package Java::Class::Fields;

use Moose;

use Java::Class::Fields::Field;

extends 'Java::Class::ElementWithCp';

has count => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_count'
);

has fields => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::Class::Fields::Field]',
	default	=> sub { [] }
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_count( $reader->read_u2 );
	for(1..$self->count) {
		push @{$self->fields}, Java::Class::Fields::Field->new( reader => $reader, constant_pool => $self->constant_pool );
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
