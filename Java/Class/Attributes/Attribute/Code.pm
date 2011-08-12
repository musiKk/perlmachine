package Java::Class::Attributes::Attribute::Code;

use Moose;

extends 'Java::Class::Attributes::Attribute';

has 'max_stack' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_max_stack'
);

has 'max_locals' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_max_locals'
);

has 'code_length' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_code_length'
);

has 'code' => (
	is		=> 'ro',
	isa		=> 'Str',
	writer	=> '_code'
);

has 'exception_tables' => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::Class::Attributes::Attribute::Code::ExceptionTable]',
	default	=> sub { [] }
);

has 'attributes' => (
	is		=> 'ro',
	isa		=> 'Java::Class::Attributes',
	writer	=> '_attributes'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_max_stack( $reader->read_u2 );
	$self->_max_locals( $reader->read_u2 );
	$self->_code_length( $reader->read_u4 );
	$self->_code( $reader->read_bytes( $self->code_length ) );
	
	my $exception_table_count = $reader->read_u2;
	for(1..$exception_table_count) {
		push @{$self->exception_tables}, Java::Class::Attributes::Attribute::Code::ExceptionTable->new( reader => $reader );
	}
	
	$self->_attributes( Java::Class::Attributes->new( reader => $reader, constant_pool => $self->constant_pool ) );
}

1;
