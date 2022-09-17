require "test_helper"

class WeekChannelTest < ActionCable::Channel::TestCase

  test "subscribes" do
    subscribe week_id: '2022-06-06'
    assert subscription.confirmed?
    assert_has_stream 'week_channel_2022-06-06'
  end

  test "no stream for invalid week_id" do
    subscribe week_id: "07/07/2022"

    assert_no_streams
  end

  test "no subscription if match identifier not preset" do
    subscribe
    assert subscription.rejected?
  end

  test "assert reminders are sent" do
    subscribe week_id: '2022-06-06'
    assert subscription.confirmed?
    assert_has_stream 'week_channel_2022-06-06'
    assert_broadcast_on(WeekChannel.broadcasting_for("week_channel_2022-06-06"), week_reminders: "reminder") do
      WeekChannel.broadcast_to 'week_channel_2022-06-06', week_reminders: "reminder"
    end
  end

  test "assert unsubscribe is working" do
    subscribe week_id: '2022-06-06'
    assert subscription.confirmed?
    assert_has_stream 'week_channel_2022-06-06'
    unsubscribe
    assert_no_streams
  end


end
