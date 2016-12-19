describe Versi::Interfaces::GitInterface do
  subject { described_class.new(remote: "uk") }
  
  describe "#initialize" do
    context "given nil remote" do
      subject { described_class.new(remote: nil) }
      
      it "should use origin remote" do
        expect(subject.instance_variable_get("@remote")).to eq("origin")
      end
    end
  end

  describe "#create_tag" do
    it "should call the git tag command" do
      expect(System).to receive(:call!).with("git tag -a \"v1.1.1\" -m \"The new mission\"")
      subject.create_tag("v1.1.1", "The new mission")
    end
  end

  describe "#delete_tag" do
    it "should call the git tag -d command" do
      expect(System).to receive(:call!).with("git tag -d \"v1.1.1\"")
      subject.delete_tag("v1.1.1")
    end
  end

  describe "#delete_tag_remote" do
    it "should call the git push --delete command with the correct remote" do
      expect(System).to receive(:call!).with("git push uk --delete \"v1.1.1\"")
      subject.delete_tag_remote("v1.1.1")
    end
  end

  describe "#push_tag" do
    it "should call the git push command with the correct remote" do
      expect(System).to receive(:call!).with("git push uk v1.1.1")
      subject.push_tag("v1.1.1")
    end
  end

  describe "#fetch_tags" do
    it "should call the git fetch --tags command" do
      expect(System).to receive(:call!).with("git fetch --tags")
      subject.fetch_tags
    end
  end

  describe "#list_tags" do
    it "should call the git tag --list command" do
      expect(System).to receive(:call!).with("git tag --list").
        and_return(double(stdout: "a\nb\nc"))
      expect(subject.list_tags).to eq(["a", "b", "c"])
    end
  end
  
  describe "#last_commit_message" do
    it "should call the git log command" do
      expect(System).to receive(:call!).with("git log -1 --pretty=%B").
        and_return(double(stdout: "some commit message\n"))
      expect(subject.last_commit_message).to eq("some commit message\n")
    end
  end
end
