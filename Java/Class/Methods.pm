package Java::Class::Methods;

use Moose;

use Java::Class::Methods::Method;

extends 'Java::Class::ElementWithCp';

has count => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_count'
);

has methods => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::Class::Methods::Method]',
	default	=> sub { [] }
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	my $cp = $self->constant_pool;
	
	$self->_count( $reader->read_u2 );
	for(1..$self->count) {
		push @{$self->methods}, Java::Class::Methods::Method->new( reader => $reader, constant_pool => $cp );
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
