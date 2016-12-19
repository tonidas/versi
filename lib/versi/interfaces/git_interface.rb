require "system"

class Versi < Clamp::Command
  module Interfaces
    class GitInterface
      DEFAULT_REMOTE = "origin"
      GIT_TAG_LIST_COMMAND = "git tag --list"
      GIT_FETCH_TAGS_COMMAND = "git fetch --tags"
      GIT_LAST_COMMIT_MSG_COMMAND = "git log -1 --pretty=%B"

      def initialize(remote:)
        remote ||= DEFAULT_REMOTE
        @remote = remote
      end

      def create_tag(tag, message=nil)
        Versi::LOG.info("Generating git tag \"#{tag}\".. ")
        System.call!("git tag -a \"#{tag}\" -m \"#{message}\"")
      end

      def delete_tag(tag)
        Versi::LOG.info("Deleting git tag \"#{tag}\".. ")
        System.call!("git tag -d \"#{tag}\"")
      end

      def delete_tag_remote(tag)
        Versi::LOG.info("Deleting git tag \"#{tag}\" on remote (#{@remote}).. ")
        System.call!("git push #{@remote} --delete \"#{tag}\"")
      end

      def push_tag(tag)
        Versi::LOG.info("Pushing \"#{tag}\" git tag.. ")
        System.call!("git push #{@remote} #{tag}")
      end

      def fetch_tags
        Versi::LOG.info("Updating local git tags.. ")
        System.call!(GIT_FETCH_TAGS_COMMAND)
      end

      def list_tags
        response = System.call!(GIT_TAG_LIST_COMMAND)
        response.stdout.split("\n")
      end
      
      def last_commit_message
        System.call!(GIT_LAST_COMMIT_MSG_COMMAND).stdout
      end
    end
  end
end
