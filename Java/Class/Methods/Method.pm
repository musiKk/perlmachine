package Java::Class::Methods::Method;

use Moose;

use Java::Class::Attributes;

extends 'Java::Class::ElementWithCp';

our %ACCESS_FLAGS = (
	PUBLIC			=> 0x0001,
	PRIVATE			=> 0x0002,
	PROTECTED		=> 0x0004,
	STATIC			=> 0x0008,
	FINAL			=> 0x0010,
	SYNCHRONIZED	=> 0x0020,
	NATIVE			=> 0x0100,
	ABSTRACT		=> 0x0400,
	STRICT			=> 0x0800
);

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

has descriptor => (
	is		=> 'ro',
	isa		=> 'Str',
	lazy	=> 1,
	default	=> sub {
		my $self = shift;
		return $self->constant_pool->get_utf8_info( $self->descriptor_index )->string;
	}
);

has attributes => (
	is		=> 'ro',
	isa		=> 'Java::Class::Attributes',
	writer	=> '_attributes'
);

# convenience method that fetches the 'Code' attribute
has code_raw => (
	is		=> 'ro',
	isa		=> 'Str',
	lazy	=> 1,
	default	=> sub {
		my $self = shift;
		return $self->_get_attribute( 'Code' )->code;
	}
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	my $cp = $self->constant_pool;
	
	$self->_access_flags( $reader->read_u2 );
	$self->_name_index( $reader->read_u2 );
	$self->_descriptor_index( $reader->read_u2 );
	
	$self->_attributes( Java::Class::Attributes->new( reader => $reader, constant_pool => $cp ) );
}

sub _get_attribute {
	my $self = shift;
	my $target_attribute = shift;;
	for my $attribute (@{$self->attributes->attributes}) {
		if($attribute->name eq $target_attribute) {
			return $attribute;
		}
	}
	return undef;
}

sub is_public		{ my $self = shift; $self->_check_acc_flag( 'PUBLIC' ) }
sub is_private		{ my $self = shift; $self->_check_acc_flag( 'PRIVATE' ) }
sub is_protected	{ my $self = shift; $self->_check_acc_flag( 'PROTECTED' ) }
sub is_static		{ my $self = shift; $self->_check_acc_flag( 'STATIC' ) }
sub is_final		{ my $self = shift; $self->_check_acc_flag( 'FINAL' ) }
sub is_synchronized	{ my $self = shift; $self->_check_acc_flag( 'SYNCHRONIZED' ) }
sub is_native		{ my $self = shift; $self->_check_acc_flag( 'NATIVE' ) }
sub is_abstract		{ my $self = shift; $self->_check_acc_flag( 'ABSTRACT' ) }
sub is_strict		{ my $self = shift; $self->_check_acc_flag( 'STRICT' ) }

sub _check_acc_flag {
	my $self = shift;
	my $flag_name = shift;
	
	$self->access_flags & $ACCESS_FLAGS{$flag_name};
}

__PACKAGE__->meta->make_immutable;
