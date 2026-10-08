const avatarTones = Object.freeze([
  'tone-lilac',
  'tone-peach',
  'tone-mint',
  'tone-sky',
  'tone-rose',
  'tone-gold',
  'tone-blue'
])

export function getDisplayName(user, fallback, fields = ['full_name', 'username', 'name']) {
  return fields.map((field) => user?.[field]).find(Boolean) || fallback
}

export function getInitials(name, fallback = 'TM') {
  return name.split(/[\s._-]+/).filter(Boolean).slice(0, 2).map((part) => part[0]).join('').toUpperCase() || fallback
}

export function getAvatarTone(index) {
  return avatarTones[index % avatarTones.length]
}
