-- ALTERING TABLES -- PRIMARY KEYS
ALTER TABLE public.orders ADD CONSTRAINT orders_pk PRIMARY KEY (order_id);
ALTER TABLE public.customers ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);
ALTER TABLE public.products ADD CONSTRAINT products_pk PRIMARY KEY (product_id);
ALTER TABLE public.sellers ADD CONSTRAINT sellers_pk PRIMARY KEY (seller_id);
ALTER TABLE public.translations ADD CONSTRAINT translation_pk PRIMARY KEY (product_category_name);


-- ALTERING TABLES -- FOREIGN KEYS
ALTER TABLE public.reviews ADD CONSTRAINT reviews_fk FOREIGN KEY (order_id) REFERENCES public.orders(order_id);
ALTER TABLE public.order_items ADD CONSTRAINT order_items_fk FOREIGN KEY (order_id) REFERENCES public.orders(order_id);
ALTER TABLE public.payments ADD CONSTRAINT payments_fk FOREIGN KEY (order_id) REFERENCES public.orders(order_id);
ALTER TABLE public.order_items ADD CONSTRAINT order_item_seller_fk FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);
ALTER TABLE public.orders ADD CONSTRAINT orders_customer_id_fk FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);
ALTER TABLE public.order_items ADD CONSTRAINT order_item_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


-- problems with product key "perfumaria" not present in table translation
-- this needs to be checked with the CSV files
ALTER TABLE public.products ADD CONSTRAINT products_transl_fk FOREIGN KEY (product_category_name) REFERENCES public.translations(product_category_name);