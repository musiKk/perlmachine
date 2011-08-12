package Java::Class::Attributes::Attribute;

use Moose;

extends 'Java::Class::ElementWithCp';

has 'name_index' => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

has 'name' => (
	is		=> 'ro',
	isa		=> 'Str',
	lazy	=> 1,
	default	=> sub {
		my $self = shift;
		return $self->constant_pool->get_utf8( $self->name_index )->string;
	}
);

has 'length' => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
}

1;
