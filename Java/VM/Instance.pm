package Java::VM::Instance;

use Moose;

use Carp;

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
	
	my @fields = @{$class->fields->fields};
	my %variables = %{$self->variables};
	for my $field (@fields) {
		next if $field->is_static;
		
		my $variable = Java::VM::ClassVariable->new( field => $field );
		$variable->set_default;
		$variables{$field->name} = $variable;
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
