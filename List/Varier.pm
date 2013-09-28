package List::Varier;
use strict;

use List::Permutor;
use List::Combiner;

sub new {
    my $class = shift;
    my $length = shift;
    my $items = shift;

    my $combiner = new List::Combiner($length, $items);
    my $permutor = new List::Permutor($combiner->next);

    return bless [ $combiner, $permutor, $items, $length ], $class;
}

sub reset {
    my $self = shift;

    $self->[0]->reset;
    $self->[1] = new List::Permutor($self->[0]->next);

    return 1;          # No useful return value
}

sub peek {
    my $self = shift;

    return $self->[1]->peek;
}

sub next {
    my $self = shift;

    my $combiner = $self->[0];
    my $permutor = $self->[1];

    my @next = $permutor->next;

    if(not @next){
	@next = $combiner->next;
	if(@next){
	    $self->[1] = new List::Permutor(@next);
	    $self->[1]->next;
	}
    }

    return @next
}

1;
__END__
