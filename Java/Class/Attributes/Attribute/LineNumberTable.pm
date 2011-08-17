package Java::Class::Attributes::Attribute::LineNumberTable;

use Moose;

extends 'Java::Class::Attributes::Attribute';

has line_number_table => (
	is		=> 'ro',
	isa		=> 'ArrayRef[ArrayRef]',
	default	=> sub { [] }
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	my $line_number_table_length = $reader->read_u2;
	
	for(1..$line_number_table_length) {
		my $start_pc = $reader->read_u2;
		my $end_pc = $reader->read_u2;
		
		push @{$self->line_number_table}, [ $start_pc, $end_pc ];
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
