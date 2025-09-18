String getAssetIcon(String assetType, String assetSubType) {
  // Bilezik kontrolü
  if (assetSubType == 'bracelet') {
    switch (assetType.toUpperCase()) {
      case 'AYAR14':
        return '🔗'; // 14K bilezik (zincir)
      case 'AYAR22':
        return '📿'; // 22K bilezik (daha değerli, tespih görünümü)
      case 'ALTIN':
      case 'KULCEALTIN':
        return '📿'; // Altın bilezik
      case 'GUMUSTRY':
        return '⚪'; // Gümüş bilezik (beyaz/gümüş renk)
      default:
        return '🔗'; // Genel bilezik
    }
  }

  // Normal ürünler (külçe/gram)
  switch (assetType.toUpperCase()) {
    case 'AYAR14':
      return '🪙'; // 14K altın külçe/sikke
    case 'AYAR22':
      return '🥇'; // 22K altın külçe (daha değerli)
    case 'ALTIN':
    case 'KULCEALTIN':
      return '🧈'; // Külçe altın (gerçek külçe görünümü)
    case 'USDTRY':
      return '💵'; // Dolar banknotu
    case 'EURTRY':
      return '💶'; // Euro banknotu
    case 'GBPTRY':
      return '💷'; // Sterlin banknotu
    case 'GUMUSTRY':
      return '🥈'; // Gümüş külçe/madalya
    case 'PLATIN':
      return '💎'; // Platin (değerli taş görünümü)
    default:
      return '💰'; // Genel para torbası
  }
}
