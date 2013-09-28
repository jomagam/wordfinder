package List::Combiner;
use strict;

sub new {
    my $class = shift;
    my $length = shift;
    my $items = shift;
    return bless [ $length, $items, [ 0 .. $length-1 ] ], $class;
}

sub reset {
    my $self = shift;

    my $length = $self->[0];
    $self->[2] = [ 0 .. $length-1];

    return 1;          # No useful return value
}

sub peek {
    my $self = shift;
    my $items = $self->[1];
    my $slice = $self->[2];
    return @$items[@$slice];
}

sub next {
    my $self = shift;

    my $length = $self->[0];
    my $items = $self->[1];
    my $rv = $self->[2];        # return value array

    return unless @$rv;

    my @next = @$rv;
    BUMPING: for(my $bumpme_offset = $length-1; $bumpme_offset >= 0; $bumpme_offset--){
	if(++$next[$bumpme_offset] == @$items - $length + $bumpme_offset + 1){
	    $next[$bumpme_offset] = $next[$bumpme_offset-1] + 2;
	    foreach(my $reset_offset = $bumpme_offset+1; $reset_offset<$length; $reset_offset++){
		$next[$reset_offset] = $next[$bumpme_offset] + $reset_offset - $bumpme_offset;
	    }
	}
	else {
	    last BUMPING;
	}
    }
    undef @next if $next[0] > @$items;
    $self->[2] = \@next;

    return @$items[@$rv];
}

1;
__END__
