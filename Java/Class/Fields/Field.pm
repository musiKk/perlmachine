package Java::Class::Fields::Field;

use Moose;

use Java::Class::Attributes;

extends 'Java::Class::ElementWithCp';

our %ACCESS_FLAGS = (
	PUBLIC		=> 0x0001,
	PRIVATE		=> 0x0002,
	PROTECTED	=> 0x0004,
	STATIC		=> 0x0008,
	FINAL		=> 0x0010,
	VOLATILE	=> 0x0040,
	TRANSIENT	=> 0x0080
);

# the preferred way to test for these is via the various is_ methods
has access_flags => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_access_flags'
);

has name_index => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_name_index'
);

has name => (
	is		=> 'ro',
	isa		=> 'Str',
	lazy	=> 1,
	default	=> sub {
		my $self = shift;
		return $self->constant_pool->get_utf8_info( $self->name_index )->string;
	}
);

has descriptor_index => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_descriptor_index'
);

# convenience method that gets this field's descriptor as a string from the constant pool
has descriptor => (
	is		=> 'ro',
	isa		=> 'Str',
	lazy	=> 1,
	default	=> sub {
		my $self = shift;
		return $self->constant_pool->get_utf8_info( $self->descriptor_index )->string;
	}
);

has attriutes => (
	is		=> 'ro',
	isa		=> 'Java::Class::Attributes',
	writer	=> '_attributes'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_access_flags( $reader->read_u2 );
	$self->_name_index( $reader->read_u2 );
	$self->_descriptor_index( $reader->read_u2 );
	
	$self->_attributes( Java::Class::Attributes->new( reader => $reader, constant_pool => $self->constant_pool ) );
}

sub is_public		{ my $self = shift; $self->_check_acc_flag( 'PUBLIC' ) }
sub is_private		{ my $self = shift; $self->_check_acc_flag( 'PRIVATE' ) }
sub is_protected	{ my $self = shift; $self->_check_acc_flag( 'PROTECTED' ) }
sub is_static		{ my $self = shift; $self->_check_acc_flag( 'STATIC' ) }
sub is_final		{ my $self = shift; $self->_check_acc_flag( 'FINAL' ) }
sub is_volatile		{ my $self = shift; $self->_check_acc_flag( 'VOLATILE' ) }
sub is_transient	{ my $self = shift; $self->_check_acc_flag( 'TRANSIENT' ) }

sub _check_acc_flag {
	my $self = shift;
	my $flag_name = shift;
	
	$self->access_flags & $ACCESS_FLAGS{$flag_name};
}

no Moose;

__PACKAGE__->meta->make_immutable;
