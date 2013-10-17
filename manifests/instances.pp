# Create all virtual hosts from hiera
class hermannherbarium::instances
{
  create_resources('apache::vhost', hiera('hermannherbarium', []))
}
