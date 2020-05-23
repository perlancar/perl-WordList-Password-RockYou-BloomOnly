package WordList::Password::RockYou::BloomOnly;

# AUTHORITY
# DATE
# DIST
# VERSION

use parent qw(WordList);

our $SORT = 'popularity';

our %STATS = (
    'num_words' => 14344391,
);

my $bloom;
sub word_exists {
    my ($self, $word) = @_;

    unless ($bloom) {
        require Algorithm::BloomFilter;
        require File::ShareDir;
        require File::Slurper;

        my $dir;
        eval {
            $dir = dist_dir('WordList-Password-RockYou-BloomOnly');
        };
        if ($@) {
            $dir = "share";
        }
        (-d $dir) or die "Can't find share dir";
        my $path = "$dir/bloom";
        (-f $path) or die "Can't find bloom filter data file '$path'";
        $bloom = Algorithm::BloomFilter->deserialize(File::Slurper::read_binary($path));
    }
    $bloom->test($word);
}

1;
# ABSTRACT: RockYou password wordlist (~14.3mil passwords) (bloom-only edition)

=head1 DESCRIPTION

C<word_exists()> can be used to test a string against the RockYou password
wordlist (~14.3 million passwords). You can use it with, e.g.
L<App::PasswordWordListUtils>'s L<exists-in-password-wordlist>. Uses bloom
filter (0.1% false positive rate).

The other methods like C<each_word()>, C<all_words()>, C<first_word()>,
C<next_word()> will return empty list of words, because this distribution only
contains the bloom filter and not the actual wordlist.


=head1 METHODS

=head2 word_exists

=cut
