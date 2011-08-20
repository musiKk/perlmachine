package Java::VM::Instance;

use Moose;

use Carp;
use overload '""' => \&stringify;

has class => (
	is			=> 'ro',
	isa			=> 'Maybe[Java::VM::LoadedClass]',
	default		=> undef
);

# these are the instance variables
# variable name => variable
has variables => (
	is			=> 'ro',
	isa			=> 'HashRef[Java::VM::ClassVariable]',
	required	=> 1,
	default		=> sub { {} }
);

has null => (
	is			=> 'ro',
	isa			=> 'Bool',
	default		=> 0
);

sub BUILD {
	my $self = shift;
	return if $self->null;
	
	my $class = $self->class;
	confess 'no class provided' unless $class;
	
	my @fields = @{$class->class->fields->fields};
	for my $field (@fields) {
		next if $field->is_static;
		
		my $variable = Java::VM::ClassVariable->new( field => $field );
		$variable->set_default;
		$self->variables->{$field->name} = $variable;
	}
}

sub stringify {
	my $self = shift;
	
	if( ! $self->null ) {
		'instance of class ' . $self->class->class->get_name . '; vars: ' . join(', ', keys %{$self->variables});
	} else {
		'null-instance';
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
