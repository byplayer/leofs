.PHONY: deps test

all: deps compile

prepare:
	mkdir -p ./apps
	(cd apps/ && git clone https://github.com/leo-project/leo_manager.git)
	(cd apps/ && git clone https://github.com/leo-project/leo_storage.git)
	(cd apps/ && git clone https://github.com/leo-project/leo_gateway.git)

compile:
	@./rebar compile
	rm -rf deps/cherly
	(cd apps/leo_gateway/cherly && make clean && make)
	(cp -r apps/leo_gateway/cherly deps/)

deps:
	@./rebar get-deps
clean:
	@./rebar clean
xref:
	@./rebar xref
eunit:
	@./rebar eunit

generate:
	rm -rf rel/leo_manager/leo_manager/
	rm -rf rel/leo_storage/leo_storage/
	rm -rf rel/leo_gateway/leo_gateway/
	@./rebar compile
	(cd rel/leo_manager && ../../rebar generate)
	(cd rel/leo_storage && ../../rebar generate)
	(cd rel/leo_gateway && ../../rebar generate)

release:
	@./rebar compile
	rm -rf package/leofs
	##
	## manager-master
	##
	rm -rf rel/leo_manager/leo_manager/
	mkdir -p package/leofs/manager_0
	cp rel/leo_manager/vars/manager_master_vars.config rel/leo_manager/vars.config
	(cd rel/leo_manager && ../../rebar generate)
	cp -r rel/leo_manager/leo_manager/* package/leofs/manager_0/	
	##
	## manager-slave
	##
	rm -rf rel/leo_manager/leo_manager/
	mkdir -p package/leofs/manager_1
	cp rel/leo_manager/vars/manager_slave_vars.config rel/leo_manager/vars.config
	(cd rel/leo_manager && ../../rebar generate)
	cp -r rel/leo_manager/leo_manager/* package/leofs/manager_1/
	##
	## release_storage
	##
	rm -rf rel/leo_storage/leo_storage/
	mkdir -p package/leofs/storage
	(cd rel/leo_storage && ../../rebar generate)
	cp -r rel/leo_storage/leo_storage/* package/leofs/storage/
	##
	## release_gateway
	##
	rm -rf rel/leo_gateway/leo_gateway/
	mkdir -p package/leofs/gateway
	(cd rel/leo_gateway && ../../rebar generate)
	cp -r rel/leo_gateway/leo_gateway/* package/leofs/gateway/

