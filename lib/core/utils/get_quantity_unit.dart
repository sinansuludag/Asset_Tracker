String getQuantityUnit(String assetType, bool isBracelet) {
  switch (assetType.toLowerCase()) {
    case 'altin':
    case 'kulcealtin':
    case 'gumustry':
      return 'gram';
    case 'ayar14':
    case 'ayar22':
      return isBracelet ? 'adet' : 'gram';
    case 'usdtry':
      return 'USD';
    case 'eurtry':
      return 'EUR';
    case 'gbptry':
      return 'GBP';
    default:
      return 'adet';
  }
}
