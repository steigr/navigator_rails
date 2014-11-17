NavigatorRails.config do
  use    devise: '/head/right'
  use    :cancan
  use    :rolify
  brand  path: :head, content: '<span class="ion-cube"></span>Project Name'
end