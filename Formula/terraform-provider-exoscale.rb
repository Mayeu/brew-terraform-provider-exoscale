require "language/go"

class TerraformProviderExoscale < Formula
  desc "Exoscale provide for Terraform"
  homepage "https://github.com/exoscale/terraform-provider-exoscale"
  head "https://github.com/exoscale/terraform-provider-exoscale.git"

  depends_on "go" => :build
  depends_on "terraform" => :run

  go_resource "github.com/hashicorp/terraform" do
    url "https://github.com/hashicorp/terraform.git", :revision => "fcf12bc46a34716652a5b9a4d7905361003293e7"
  end

  go_resource "github.com/pyr/egoscale" do
    url "https://github.com/pyr/egoscale.git", :revision => "ab4b0d7ff424c462da486aef27f354cdeb29a319"
  end

  go_resource "gopkg.in/amz.v2" do
    url "https://github.com/go-amz/amz.git", :revision => "4cc0b98d82c6bc08435ddab2d5ba459a6b173880"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "install", "github.com/cab105/terraform-provider-exoscale/"
    bin.install "bin/terraform-provider-exoscale"
  end

  def caveats
    <<-EOS.undent
      Once installed a $HOME/.terraformrc file is used to enable the plugin:

      provider {
        exoscale = "#{HOMEBREW_PREFIX}/bin/terraform-provider-exoscale"
      }
    EOS
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-exoscale 2>&1", 1))
  end
end
