package Java::VM::Classloader;

use Moose;

has loaded_classes => (
	is		=> 'ro',
	isa		=> 'HashRef[Java::VM::LoadedClass]',
	default	=> sub { {} },
	reader	=> '_loaded_classes'
);

sub load_class {
	die 'abstract classloader can\'t load classes';
}

sub get_loaded_class {
	my $self = shift;
	my $class_name = shift;
	$self->_loaded_classes->{$class_name};
}

sub register_class {
	my $self = shift;
	my $class = shift;
	
	$self->_loaded_classes->{$class->class->get_name} = $class;
}

no Moose;

__PACKAGE__->meta->make_immutable;
