
class Character{
  final String title;
  final String description;
  final String avatar;

  Character( {
    required this.title,
    required this.description,
    required this. avatar,

  });
}

final characters=<Character>[
  Character(
    title: 'Big Sean',
    description: 'Artist',
    avatar: 'assets/images/sean.jpeg',
  ),
  Character(
      title: 'Drake',
      description: 'Artist',
      avatar: 'assets/images/drake.jpeg'

  ),
  Character(
      title: 'Burna Boy',
      description: 'Artist',
      avatar: 'assets/images/burna.jpeg'

  ),
  Character(
      title: 'Rema',
      description: 'Artist',
      avatar: 'assets/images/rema.jpeg'

  ),
  Character(
      title: '21 Savage',
      description: 'Artist',
      avatar: 'assets/images/savage.jpeg'

  ),
  Character(
      title: 'Jason Derulo',
      description: 'Artist',
      avatar: 'assets/images/rulo.jpeg'

  ),

  Character(
      title: 'Meek Mill',
      description: 'Artist',
      avatar: 'assets/images/meel.jpeg'

  ),


  Character(
        title: 'Travis Scott',
      description: 'Artist',
      avatar: 'assets/images/scot.jpeg'

  ),
  Character(
      title: ' Lil Baby',
      description: 'Artist',
      avatar: 'assets/images/lil.jpeg'

  ),

];