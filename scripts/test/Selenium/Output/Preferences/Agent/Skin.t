# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Miscellaneous");

        # change test users skin to ivory
        $Selenium->execute_script("\$('#UserSkin').val('ivory').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script(
            "\$('#UserSkin').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserSkin').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserSkin').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserSkin').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
    }
);

1;
